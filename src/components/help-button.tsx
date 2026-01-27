import { HelpCircleIcon } from './icons';

interface HelpButtonProps {
  /** Called when help button is clicked */
  onClick: () => void;
}

/** Help button positioned in top-right corner of panel */
export function HelpButton({ onClick }: HelpButtonProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-label="Show help"
      className="absolute top-2 right-2 p-1.5 text-gray-500 hover:text-gray-700 rounded-button hover:bg-black/5 focus:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring transition-colors"
    >
      <HelpCircleIcon className="w-5 h-5" />
    </button>
  );
}
