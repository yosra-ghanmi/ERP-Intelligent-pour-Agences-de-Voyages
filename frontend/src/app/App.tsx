import { AppProviders } from "@/core/providers/AppProviders";
import { AppRoutes } from "@/core/routes/AppRoutes";
import "@/core/i18n";

export const App = () => {
  return (
    <AppProviders>
      <AppRoutes />
    </AppProviders>
  );
};
