import { PropsWithChildren } from "react";
import { clsx } from "clsx";

export const Badge = ({
  children,
  className,
  variant = "default",
}: PropsWithChildren<{ className?: string; variant?: "default" | "success" | "warning" | "danger" }>) => {
  const variants: Record<string, string> = {
    default: "bg-secondary text-secondaryForeground",
    success: "bg-emerald-500 text-white",
    warning: "bg-amber-500 text-white",
    danger: "bg-rose-500 text-white",
  };
  return <span className={clsx("rounded-full px-2.5 py-1 text-xs font-medium", variants[variant], className)}>{children}</span>;
};
