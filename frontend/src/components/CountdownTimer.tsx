import React, { useState, useEffect } from 'react';

interface CountdownTimerProps {
  className?: string;
}

export const CountdownTimer: React.FC<CountdownTimerProps> = ({ className = '' }) => {
  const [timeLeft, setTimeLeft] = useState<{ hours: number; minutes: number; seconds: number }>({
    hours: 0,
    minutes: 0,
    seconds: 0
  });

  useEffect(() => {
    const calculateTimeLeft = () => {
      const now = new Date();
      const tomorrow = new Date(now);
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(0, 0, 0, 0);
      
      const diff = tomorrow.getTime() - now.getTime();
      
      const hours = Math.floor(diff / (1000 * 60 * 60));
      const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((diff % (1000 * 60)) / 1000);
      
      return { hours, minutes, seconds };
    };

    // Initial calculation
    setTimeLeft(calculateTimeLeft());

    // Update every second
    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const pad = (num: number): string => num.toString().padStart(2, '0');

  return (
    <div className={`text-center ${className}`}>
      <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Next puzzle in</p>
      <div className="flex items-center justify-center gap-1 font-mono text-2xl font-bold dark:text-white">
        <span className="bg-gray-200 dark:bg-gray-700 px-2 py-1 rounded">{pad(timeLeft.hours)}</span>
        <span>:</span>
        <span className="bg-gray-200 dark:bg-gray-700 px-2 py-1 rounded">{pad(timeLeft.minutes)}</span>
        <span>:</span>
        <span className="bg-gray-200 dark:bg-gray-700 px-2 py-1 rounded">{pad(timeLeft.seconds)}</span>
      </div>
    </div>
  );
};
