import { forwardRef, InputHTMLAttributes } from "react";
import { clsx } from "clsx";

export const Input = forwardRef<HTMLInputElement, InputHTMLAttributes<HTMLInputElement>>(({ className, ...props }, ref) => {
  return (
    <input
      ref={ref}
      className={clsx(
        "flex h-12 w-full rounded-xl border border-border bg-white/90 px-4 text-sm text-foreground shadow-[0_6px_18px_rgba(15,23,42,0.06)] outline-none transition focus:border-sky-300 focus:ring-2 focus:ring-sky-200",
        className
      )}
      {...props}
    />
  );
});
