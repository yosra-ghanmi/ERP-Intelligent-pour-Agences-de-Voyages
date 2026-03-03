import { Routes, Route } from "react-router-dom";
import { ProtectedRoute } from "@/core/guards/ProtectedRoute";
import { RoleRoute } from "@/core/guards/RoleRoute";
import { AppLayout } from "@/shared/layout/AppLayout";
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
import { HomePage } from "@/core/routes/HomePage";

export const AppRoutes = () => {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <AppLayout>
              <HomePage />
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/services"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "TravelAgent"]}>
                <ServicesPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/clients"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "TravelAgent"]}>
                <ClientsPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/reservations"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "TravelAgent"]}>
                <ReservationsPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/quotes"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "TravelAgent"]}>
                <QuotesPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/invoices"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "Accountant"]}>
                <InvoicesPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/payments"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "Accountant"]}>
                <PaymentsPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/ai"
        element={
          <ProtectedRoute>
            <AppLayout>
              <RoleRoute allow={["Admin", "TravelAgent"]}>
                <AIPage />
              </RoleRoute>
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/settings"
        element={
          <ProtectedRoute>
            <AppLayout>
              <SettingsPage />
            </AppLayout>
          </ProtectedRoute>
        }
      />
      <Route
        path="/profile"
        element={
          <ProtectedRoute>
            <AppLayout>
              <ProfilePage />
            </AppLayout>
          </ProtectedRoute>
        }
      />
    </Routes>
  );
};
