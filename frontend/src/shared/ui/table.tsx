import { PropsWithChildren } from "react";
import { clsx } from "clsx";

export const Table = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <table className={clsx("table-zebra w-full text-sm", className)}>{children}</table>;
};

export const THead = ({ children }: PropsWithChildren) => (
  <thead className="text-slate-600 uppercase tracking-wide text-xs dark:text-slate-300">{children}</thead>
);
export const TRow = ({ children, className }: PropsWithChildren<{ className?: string }>) => (
  <tr className={clsx("border-b border-border/70", className)}>{children}</tr>
);
export const TH = ({ children, className }: PropsWithChildren<{ className?: string }>) => (
  <th className={clsx("px-4 py-4 text-left font-semibold text-slate-700 dark:text-slate-200", className)}>{children}</th>
);
export const TD = ({ children, className }: PropsWithChildren<{ className?: string }>) => (
  <td className={clsx("px-4 py-4 text-slate-700 dark:text-slate-200", className)}>{children}</td>
);
