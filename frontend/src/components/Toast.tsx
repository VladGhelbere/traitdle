import React, { useEffect, useState } from 'react';
import { FeedbackType } from '../types';

interface ToastProps {
  message: string;
  type: FeedbackType | 'win' | 'lose';
  isVisible: boolean;
  onHide: () => void;
  duration?: number;
}

export const Toast: React.FC<ToastProps> = ({ 
  message, 
  type, 
  isVisible, 
  onHide,
  duration = 1500 
}) => {
  const [show, setShow] = useState(false);

  useEffect(() => {
    if (isVisible) {
      setShow(true);
      const timer = setTimeout(() => {
        setShow(false);
        setTimeout(onHide, 300); // Wait for fade out animation
      }, duration);
      return () => clearTimeout(timer);
    }
  }, [isVisible, duration, onHide]);

  if (!isVisible && !show) return null;

  const getStyles = () => {
    switch (type) {
      case 'correct':
        return 'bg-green-500 text-white';
      case 'partial':
        return 'bg-yellow-500 text-white';
      case 'incorrect':
        return 'bg-gray-600 text-white';
      case 'win':
        return 'bg-green-500 text-white';
      case 'lose':
        return 'bg-red-500 text-white';
      default:
        return 'bg-gray-600 text-white';
    }
  };

  const getIcon = () => {
    switch (type) {
      case 'correct':
        return '✓';
      case 'partial':
        return '≈';
      case 'incorrect':
        return '✗';
      case 'win':
        return '🎉';
      case 'lose':
        return '💥';
      default:
        return '';
    }
  };

  return (
    <div className="fixed top-20 left-1/2 transform -translate-x-1/2 z-50 pointer-events-none">
      <div 
        className={`px-4 py-2 rounded-lg shadow-lg font-semibold flex items-center gap-2 transition-all duration-300 ${getStyles()} ${
          show ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'
        }`}
      >
        <span className="text-lg">{getIcon()}</span>
        <span>{message}</span>
      </div>
    </div>
  );
};
