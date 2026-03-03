import { PropsWithChildren } from "react";
import { clsx } from "clsx";

export const Card = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <div className={clsx("rounded-lg border border-border bg-card shadow-soft", className)}>{children}</div>;
};

export const CardHeader = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <div className={clsx("px-5 pt-5", className)}>{children}</div>;
};

export const CardContent = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <div className={clsx("px-5 pb-5 pt-3", className)}>{children}</div>;
};
