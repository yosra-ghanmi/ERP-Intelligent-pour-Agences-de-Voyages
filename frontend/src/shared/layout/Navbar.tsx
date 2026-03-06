import { useTranslation } from "react-i18next";
import { Input } from "@/shared/ui/input";
import { UserMenu } from "@/shared/components/UserMenu";

export const Navbar = () => {
  const { t } = useTranslation();
  return (
    <header className="flex w-full items-center justify-between">
      <div className="text-lg font-bold text-[#1a365d]">{t("nav.dashboard")}</div>
      <div className="flex items-center gap-3">
        <Input
          placeholder="Search..."
          className="h-10 w-64 rounded-full border-slate-200 bg-white/80 text-sm shadow-sm focus:border-[#0070f3]"
        />
        <UserMenu />
      </div>
    </header>
  );
};
