import { Routes, Route, useLocation, Navigate } from "react-router-dom";
import { useEffect } from "react";
import AOS from "aos";
import { ProtectedRoute } from "@/core/guards/ProtectedRoute";
import { LoginPage } from "@/features/auth/LoginPage";
import { ServicesPage } from "@/features/services/ServicesPage";
import { ClientsPage } from "@/features/clients/ClientsPage";
import { ReservationsPage } from "@/features/reservations/ReservationsPage";
import { QuotesPage } from "@/features/quotes/QuotesPage";
import { InvoicesPage } from "@/features/invoices/InvoicesPage";
import { PaymentsPage } from "@/features/payments/PaymentsPage";
import { AIPage } from "@/features/ai/AIPage";
import { SettingsPage } from "@/features/settings/SettingsPage";
import { ProfilePage } from "@/features/profile/ProfilePage";
import { DashboardPage } from "@/features/dashboard/DashboardPage";
import { AdminLayout } from "@/shared/layout/AdminLayout";
import { AgentLayout } from "@/shared/layout/AgentLayout";
import { FinanceLayout } from "@/shared/layout/FinanceLayout";
import { useAuthStore } from "@/store/auth";

const RoleRedirect = () => {
  const role = useAuthStore((s) => s.role);
  if (role === "Admin") return <Navigate to="/admin" replace />;
  if (role === "Accountant") return <Navigate to="/finance" replace />;
  if (role === "TravelAgent") return <Navigate to="/agent" replace />;
  return <Navigate to="/login" replace />;
};

export const AppRoutes = () => {
  const location = useLocation();

  useEffect(() => {
    AOS.refresh();
  }, [location.pathname]);

  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <RoleRedirect />
          </ProtectedRoute>
        }
      />
      <Route
        path="/admin/*"
        element={
          <ProtectedRoute allow={["Admin"]}>
            <AdminLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<DashboardPage />} />
        <Route path="users" element={<SettingsPage />} />
        <Route path="logs" element={<AIPage />} />
        <Route path="analytics" element={<DashboardPage />} />
      </Route>
      <Route
        path="/agent/*"
        element={
          <ProtectedRoute allow={["TravelAgent"]}>
            <AgentLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<ServicesPage />} />
        <Route path="itinerary" element={<AIPage />} />
        <Route path="crm" element={<ClientsPage />} />
        <Route path="reservations" element={<ReservationsPage />} />
        <Route path="quotes" element={<QuotesPage />} />
      </Route>
      <Route
        path="/finance/*"
        element={
          <ProtectedRoute allow={["Accountant"]}>
            <FinanceLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<InvoicesPage />} />
        <Route path="ledger" element={<PaymentsPage />} />
        <Route path="expenses" element={<PaymentsPage />} />
        <Route path="reports" element={<DashboardPage />} />
        <Route path="invoices" element={<InvoicesPage />} />
        <Route path="payments" element={<PaymentsPage />} />
      </Route>
      <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
    </Routes>
  );
};
