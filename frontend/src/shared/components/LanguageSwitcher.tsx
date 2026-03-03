import { useTranslation } from "react-i18next";
import { useAppStore } from "@/store/app";
import { Select } from "@/shared/ui/select";

export const LanguageSwitcher = () => {
  const { t } = useTranslation();
  const language = useAppStore((s) => s.language);
  const setLanguage = useAppStore((s) => s.setLanguage);
  return (
    <div className="flex items-center gap-2 text-sm">
      <span className="text-mutedForeground">{t("common.language")}</span>
      <Select value={language} onChange={(e) => setLanguage(e.target.value as "en" | "fr")} className="w-28">
        <option value="en">EN</option>
        <option value="fr">FR</option>
      </Select>
    </div>
  );
};
