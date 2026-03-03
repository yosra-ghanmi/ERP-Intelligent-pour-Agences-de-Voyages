import { useAuthStore } from "@/store/auth";
import { DashboardPage } from "@/features/dashboard/DashboardPage";
import { ServicesPage } from "@/features/services/ServicesPage";
import { InvoicesPage } from "@/features/invoices/InvoicesPage";

export const HomePage = () => {
  const role = useAuthStore((s) => s.role);
  if (role === "Accountant") return <InvoicesPage />;
  if (role === "TravelAgent") return <ServicesPage />;
  return <DashboardPage />;
};
