import { PropsWithChildren } from "react";
import { clsx } from "clsx";

export const Table = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <table className={clsx("w-full text-sm", className)}>{children}</table>;
};

export const THead = ({ children }: PropsWithChildren) => <thead className="text-mutedForeground">{children}</thead>;
export const TRow = ({ children, className }: PropsWithChildren<{ className?: string }>) => (
  <tr className={clsx("border-b border-border", className)}>{children}</tr>
);
export const TH = ({ children, className }: PropsWithChildren<{ className?: string }>) => (
  <th className={clsx("p-3 text-left font-medium", className)}>{children}</th>
);
export const TD = ({ children, className }: PropsWithChildren<{ className?: string }>) => (
  <td className={clsx("p-3", className)}>{children}</td>
);
