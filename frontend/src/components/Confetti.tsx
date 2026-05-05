import React, { useEffect, useState } from 'react';

interface ConfettiPiece {
  id: number;
  x: number;
  color: string;
  delay: number;
  duration: number;
}

interface ConfettiProps {
  active: boolean;
  duration?: number;
}

export const Confetti: React.FC<ConfettiProps> = ({ active, duration = 3000 }) => {
  const [pieces, setPieces] = useState<ConfettiPiece[]>([]);
  const [visible, setVisible] = useState(false);

  const colors = [
    '#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', 
    '#ffeaa7', '#dfe6e9', '#fd79a8', '#a29bfe',
    '#00b894', '#e17055', '#0984e3', '#6c5ce7'
  ];

  useEffect(() => {
    if (active) {
      setVisible(true);
      
      // Generate confetti pieces
      const newPieces: ConfettiPiece[] = [];
      for (let i = 0; i < 50; i++) {
        newPieces.push({
          id: i,
          x: Math.random() * 100,
          color: colors[Math.floor(Math.random() * colors.length)],
          delay: Math.random() * 0.5,
          duration: 2 + Math.random() * 2
        });
      }
      setPieces(newPieces);

      // Hide after duration
      const timer = setTimeout(() => {
        setVisible(false);
        setPieces([]);
      }, duration);

      return () => clearTimeout(timer);
    }
  }, [active, duration]);

  if (!visible || pieces.length === 0) return null;

  return (
    <div className="fixed inset-0 pointer-events-none z-50 overflow-hidden">
      {pieces.map((piece) => (
        <div
          key={piece.id}
          className="absolute w-3 h-3 rounded-sm"
          style={{
            left: `${piece.x}%`,
            top: '-20px',
            backgroundColor: piece.color,
            animation: `confetti-fall ${piece.duration}s linear ${piece.delay}s forwards`,
            transform: `rotate(${Math.random() * 360}deg)`
          }}
        />
      ))}
    </div>
  );
};
