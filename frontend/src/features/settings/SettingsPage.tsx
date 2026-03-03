import { useTranslation } from "react-i18next";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { useAppStore } from "@/store/app";
import { Button } from "@/shared/ui/button";

export const SettingsPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);
  const setDemoMode = useAppStore((s) => s.setDemoMode);
  return (
    <Card>
      <CardHeader>{t("settings.title")}</CardHeader>
      <CardContent className="flex items-center justify-between">
        <div className="text-sm">{t("settings.demoMode")}</div>
        <Button variant={demoMode ? "primary" : "outline"} onClick={() => setDemoMode(!demoMode)}>
          {demoMode ? "On" : "Off"}
        </Button>
      </CardContent>
    </Card>
  );
};
