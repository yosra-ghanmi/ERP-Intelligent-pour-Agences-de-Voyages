import { useTranslation } from "react-i18next";
import { LanguageSwitcher } from "@/shared/components/LanguageSwitcher";
import { ThemeToggle } from "@/shared/components/ThemeToggle";
import { NotificationCenter } from "@/shared/components/NotificationCenter";
import { UserMenu } from "@/shared/components/UserMenu";

export const Navbar = () => {
  const { t } = useTranslation();
  return (
    <header className="flex items-center justify-between border-b border-border px-6 py-4">
      <div className="text-lg font-semibold">{t("nav.dashboard")}</div>
      <div className="flex items-center gap-3">
        <LanguageSwitcher />
        <ThemeToggle />
        <NotificationCenter />
        <UserMenu />
      </div>
    </header>
  );
};
