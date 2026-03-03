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
    "inline-flex items-center justify-center rounded-md text-sm font-medium transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50 disabled:pointer-events-none h-10 px-4";
  const variants: Record<string, string> = {
    primary: "bg-primary text-primaryForeground hover:opacity-90",
    secondary: "bg-secondary text-secondaryForeground hover:opacity-90",
    ghost: "bg-transparent hover:bg-accent text-foreground",
    outline: "border border-border bg-transparent hover:bg-accent",
  };
  return <button className={clsx(base, variants[variant], className)} {...props} />;
};
