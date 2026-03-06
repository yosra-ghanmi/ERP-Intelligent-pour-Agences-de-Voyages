import { HTMLAttributes, PropsWithChildren } from "react";
import { clsx } from "clsx";

export const Card = ({
  children,
  className,
  ...props
}: PropsWithChildren<{ className?: string }> & HTMLAttributes<HTMLDivElement>) => {
  const dataAos = (props as Record<string, unknown>)["data-aos"] as string | undefined;
  return (
    <div
      {...props}
      data-aos={dataAos ?? "fade-up"}
      className={clsx(
        "glass-surface rounded-3xl shadow-[0_12px_30px_rgba(15,23,42,0.08)]",
        className
      )}
    >
      {children}
    </div>
  );
};

export const CardHeader = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <div className={clsx("px-6 pt-6 text-slate-900 text-base font-semibold dark:text-slate-100", className)}>{children}</div>;
};

export const CardContent = ({ children, className }: PropsWithChildren<{ className?: string }>) => {
  return <div className={clsx("px-6 pb-6 pt-4", className)}>{children}</div>;
};
