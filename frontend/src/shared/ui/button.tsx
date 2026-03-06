import { ButtonHTMLAttributes } from "react";
import { clsx } from "clsx";

export const Button = ({
  className,
  variant = "primary",
  ...props
}: ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: "primary" | "secondary" | "ghost" | "outline";
}) => {
  const base =
    "inline-flex items-center justify-center rounded-xl text-sm font-medium transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sky-300 disabled:opacity-50 disabled:pointer-events-none h-11 px-5 shadow-[0_10px_18px_rgba(14,116,144,0.15)] hover:shadow-[0_12px_24px_rgba(14,116,144,0.22)] hover:-translate-y-0.5";
  const variants: Record<string, string> = {
    primary: "bg-gradient-to-r from-blue-600 via-sky-500 to-teal-400 text-white hover:brightness-110",
    secondary: "bg-secondary text-secondaryForeground hover:bg-secondary/80",
    ghost: "bg-transparent hover:bg-accent text-foreground",
    outline: "border border-border bg-transparent hover:bg-accent",
  };
  return <button className={clsx(base, variants[variant], className)} {...props} />;
};
