import { invoke } from '@tauri-apps/api/core';
import { NextPage } from 'next';
import { useEffect, useState } from 'react';
import {
  MdLock,
  MdRefresh,
  MdSignalWifi1Bar,
  MdSignalWifi2Bar,
  MdSignalWifi3Bar,
  MdSignalWifi4Bar,
  MdWifi,
} from 'react-icons/md';

type WifiNetwork = {
  ssid: string;
  bssid: string;
  rssi: number;
  channel: string;
  secure: boolean;
};

const delay = async (seconds: number) => {
  return new Promise((resolve) => setTimeout(resolve, seconds * 1000));
};

// Map RSSI to 0-4 levels
const getSignalLevel = (rssi: number) => {
  if (rssi >= -50) return 4; // Excellent
  if (rssi >= -60) return 3; // Good
  if (rssi >= -70) return 2; // Fair
  return 1; // Weak
};

// Return the correct Wi-Fi icon
const getWifiIcon = (level: number) => {
  const size: number = 24;
  switch (level) {
    case 4:
      return <MdSignalWifi4Bar size={size} />;
    case 3:
      return <MdSignalWifi3Bar size={size} />;
    case 2:
      return <MdSignalWifi2Bar size={size} />;
    default:
      return <MdSignalWifi1Bar size={size} />;
  }
};

const HomePage: NextPage = () => {
  const [{ loading = false, error = null, networks = [] }, setState] =
    useState<{
      loading: boolean;
      error: string | null;
      networks: WifiNetwork[];
    }>({ loading: false, error: null, networks: [] });

  useEffect(() => {
    scanNetworks();
  }, []);

  const scanNetworks = async () => {
    try {
      setState((prev) => ({ ...prev, loading: true, error: null }));
      const result = await invoke<WifiNetwork[]>('list_wifi_networks');
      await delay(5);
      result.sort((a, b) => b.rssi - a.rssi);
      setState({ loading: false, error: null, networks: result });
    } catch (error) {
      setState({ loading: false, error: String(error), networks: [] });
    }
  };

  const handleConnect = async (network: WifiNetwork) => {
    console.log('Connecting to network:', network);

    try {
      const result = await invoke<string>('connect_wifi', {
        ssid: network.ssid,
        password: undefined,
      });
      alert(result);
    } catch (err) {
      alert(`Failed to connect: ${err}`);
    }
  };

  return (
    <div className="container mx-auto flex h-screen w-screen flex-col gap-y-8 overflow-hidden bg-black p-8 text-white">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-bold">Wi-Fi</h1>
        <button
          className="cursor-pointer rounded-full border border-white/20 bg-white/10 px-4 py-1.5 shadow-lg backdrop-blur-md transition-all hover:bg-white/20 active:bg-white/30 disabled:cursor-not-allowed disabled:opacity-50"
          onClick={scanNetworks}
          disabled={loading}>
          {loading ? (
            <MdWifi className="animate-spin" size={20} />
          ) : (
            <MdRefresh size={20} />
          )}{' '}
        </button>
      </div>

      {/* Error Message */}
      {!loading && error && (
        <div className="border-b border-neutral-700 bg-neutral-800 text-red-400">
          Error: {error}
        </div>
      )}

      {/* Wi-Fi List */}
      <div className="flex-1 overflow-hidden overflow-y-auto rounded-lg">
        {loading && (
          <div className="bg-opacity-80 absolute inset-0 z-10 flex flex-col items-center justify-center bg-neutral-950">
            <div className="h-8 w-8 animate-spin rounded-full border-4 border-neutral-600 border-t-white" />
            <p className="mt-2 text-sm text-neutral-300">Scanning...</p>
          </div>
        )}

        <ul className="divide-y divide-neutral-800 overflow-hidden rounded-lg bg-neutral-900 shadow-lg">
          {networks.map((network) => {
            const level = getSignalLevel(network.rssi);

            return (
              <button
                key={`network-${network.bssid}`}
                type="button"
                className="flex w-full cursor-pointer items-center space-x-3 px-6 py-3 transition-colors hover:bg-neutral-800 focus:outline-none"
                onClick={() => handleConnect(network)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' || e.key === ' ') {
                    handleConnect(network);
                  }
                }}
                aria-label={`Connect to ${network.ssid || 'Hidden'} Wi-Fi network`}>
                {/* Left side: Wi-Fi icon, SSID, Lock */}
                <div className="flex items-center justify-center rounded-full bg-neutral-800 p-2 text-white">
                  {getWifiIcon(level)}
                </div>
                <div className="flex grow items-center space-x-3">
                  <div className="flex flex-col items-start gap-y-1">
                    <span className="leading-tight font-medium">
                      {network.ssid || '<Hidden>'}
                    </span>
                    <span className="text-xs text-neutral-400">
                      Channel: {network.channel}
                    </span>
                  </div>
                </div>
                <div className="flex flex-col items-end gap-y-1">
                  {network.secure && (
                    <MdLock className="text-neutral-400" size={14} />
                  )}
                  {/* RSSI */}
                  <span className="text-sm text-neutral-400">
                    {network.rssi} dBm
                  </span>
                </div>
              </button>
            );
          })}
        </ul>
      </div>
    </div>
  );
};

export default HomePage;
