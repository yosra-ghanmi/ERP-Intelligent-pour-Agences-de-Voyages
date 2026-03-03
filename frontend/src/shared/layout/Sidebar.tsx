import { NavLink } from "react-router-dom";
import { ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { LayoutGrid, Users, CalendarDays, FileText, Receipt, CreditCard, Sparkles, Settings } from "lucide-react";
import { useAuthStore } from "@/store/auth";

type NavItem = {
  to: string;
  label: string;
  roles: ("Admin" | "TravelAgent" | "Accountant")[];
  icon: ReactNode;
};

export const Sidebar = ({ collapsed }: { collapsed: boolean }) => {
  const { t } = useTranslation();
  const role = useAuthStore((s) => s.role) || "TravelAgent";

  const items: NavItem[] = [
    { to: "/", label: t("nav.dashboard"), roles: ["Admin", "Accountant"], icon: <LayoutGrid size={18} /> },
    { to: "/services", label: t("nav.services"), roles: ["Admin", "TravelAgent"], icon: <FileText size={18} /> },
    { to: "/clients", label: t("nav.clients"), roles: ["Admin", "TravelAgent"], icon: <Users size={18} /> },
    { to: "/reservations", label: t("nav.reservations"), roles: ["Admin", "TravelAgent"], icon: <CalendarDays size={18} /> },
    { to: "/quotes", label: t("nav.quotes"), roles: ["Admin", "TravelAgent"], icon: <FileText size={18} /> },
    { to: "/invoices", label: t("nav.invoices"), roles: ["Admin", "Accountant"], icon: <Receipt size={18} /> },
    { to: "/payments", label: t("nav.payments"), roles: ["Admin", "Accountant"], icon: <CreditCard size={18} /> },
    { to: "/ai", label: t("nav.aiItinerary"), roles: ["Admin", "TravelAgent"], icon: <Sparkles size={18} /> },
    { to: "/settings", label: t("nav.settings"), roles: ["Admin", "Accountant", "TravelAgent"], icon: <Settings size={18} /> },
  ];

  return (
    <aside className={`h-full border-r border-border bg-card ${collapsed ? "w-20" : "w-64"} transition-all`}>
      <div className="px-4 py-6 text-lg font-semibold">ERP</div>
      <nav className="flex flex-col gap-1 px-2">
        {items
          .filter((item) => item.roles.includes(role))
          .map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `flex items-center gap-3 rounded-md px-3 py-2 text-sm ${
                  isActive ? "bg-accent text-accentForeground" : "text-mutedForeground hover:bg-accent"
                }`
              }
            >
              {item.icon}
              {!collapsed && <span>{item.label}</span>}
            </NavLink>
          ))}
      </nav>
    </aside>
  );
};
