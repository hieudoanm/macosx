import { invoke } from '@tauri-apps/api/core';
import Link from 'next/link';
import { FC, useEffect, useState } from 'react';
import { FaClipboard } from 'react-icons/fa6';
import { MdChevronLeft, MdRefresh } from 'react-icons/md';

type ClipboardEntry = {
  content: string;
  timestamp: number;
};

const Clipboard: FC<{
  clipboard: ClipboardEntry[];
  fetchClipboard: () => Promise<void>;
}> = ({ clipboard = [], fetchClipboard = () => {} }) => {
  if (clipboard.length === 0) {
    return (
      <p className="p-4 text-center text-neutral-500">
        No clipboard entries yet.
      </p>
    );
  }

  return (
    <ul className="divide-y divide-neutral-800 overflow-hidden rounded-lg bg-neutral-900">
      {clipboard.map((entry) => (
        <button
          type="button"
          key={entry.timestamp}
          className="flex w-full cursor-pointer flex-col items-start px-6 py-3 transition-colors hover:bg-neutral-800"
          onClick={async () => {
            console.log('Copying to clipboard:', entry.content);
            navigator.clipboard.writeText(entry.content);
            await fetchClipboard();
          }}>
          <div className="text-left text-sm text-neutral-400">
            {new Date(entry.timestamp).toLocaleString()}
          </div>
          <div className="text-left break-words">{entry.content}</div>
        </button>
      ))}
    </ul>
  );
};

const ClipboardPage = () => {
  const [{ loading, error, clipboard }, setState] = useState<{
    loading: boolean;
    error: string | null;
    clipboard: ClipboardEntry[];
  }>({ loading: true, error: null, clipboard: [] });

  const fetchClipboard = async (): Promise<void> => {
    try {
      setState({ loading: true, error: null, clipboard: [] });
      const data = await invoke<ClipboardEntry[]>('get_clipboard_history');
      // Sort by timestamp descending
      data.sort((a, b) => b.timestamp - a.timestamp);
      setState({ loading: false, error: null, clipboard: data });
    } catch (error) {
      setState({ loading: false, error: String(error), clipboard: [] });
    }
  };

  useEffect(() => {
    fetchClipboard();
  }, []);

  return (
    <div className="container mx-auto flex h-screen w-screen flex-col gap-y-8 overflow-hidden bg-black p-8 text-white">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-x-2">
          <Link href="/">
            <MdChevronLeft size={24} className="cursor-pointer" />
          </Link>
          <h1 className="text-xl font-bold">Clipboard</h1>
        </div>
        <button
          className="cursor-pointer rounded-full border border-white/20 bg-white/10 px-4 py-1.5 shadow-lg backdrop-blur-md transition-all hover:bg-white/20 active:bg-white/30 disabled:cursor-not-allowed disabled:opacity-50"
          onClick={fetchClipboard}
          disabled={loading}>
          {loading ? (
            <FaClipboard className="animate-spin" size={20} />
          ) : (
            <MdRefresh size={20} />
          )}
        </button>
      </div>

      {/* Error Message */}
      {error && (
        <div className="border-b border-neutral-700 bg-neutral-800 p-2 text-red-400">
          Error: {error}
        </div>
      )}

      {/* Clipboard List */}
      <div className="flex-1 overflow-y-auto rounded-lg bg-neutral-900 shadow-lg">
        {loading ? (
          <p className="p-4 text-neutral-400">Loading clipboard...</p>
        ) : (
          <Clipboard clipboard={clipboard} fetchClipboard={fetchClipboard} />
        )}
      </div>
    </div>
  );
};

export default ClipboardPage;
