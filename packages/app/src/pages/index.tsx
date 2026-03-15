import { NextPage } from 'next';
import Link from 'next/link';
import { FaClipboard } from 'react-icons/fa6';
import { MdWifi } from 'react-icons/md';

const HomePage: NextPage = () => {
  return (
    <div className="h-screen w-screen">
      <div className="grid h-full grid-cols-2">
        <div className="col-span-1 flex h-full flex-col items-center justify-center">
          <Link href="/clipboard">
            <button
              type="button"
              className="flex cursor-pointer flex-col items-center gap-y-2 text-center">
              <FaClipboard size={48} />
              <span>Clipboard</span>
            </button>
          </Link>
        </div>
        <div className="col-span-1 flex h-full flex-col items-center justify-center">
          <Link href="/wifi">
            <button
              type="button"
              className="flex cursor-pointer flex-col items-center gap-y-2 text-center">
              <MdWifi size={48} />
              <span>Wi-Fi</span>
            </button>
          </Link>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
