import { NavLink } from "react-router-dom";
import { ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { LayoutGrid, Users, CalendarDays, FileText, Receipt, CreditCard, Sparkles, Settings } from "lucide-react";
import { useAuthStore } from "@/store/auth";
import logo from "@/assets/logo.png";

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
    <aside
      className={`fixed left-0 top-0 z-[50] h-full border-r border-white/10 bg-[var(--sidebar-bg)] ${
        collapsed ? "w-20" : "w-64"
      } transition-all`}
    >
      <div className="flex items-center gap-3 px-4 py-6">
        <img src={logo} alt="Travel Agency ERP" className="h-12 w-12 rounded-full object-contain" />
        {!collapsed && <div className="text-lg font-semibold tracking-wide text-white">Travel Agency ERP</div>}
      </div>
      <nav className="flex flex-col gap-2 px-3 pb-6">
        {items
          .filter((item) => item.roles.includes(role))
          .map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `group relative flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition ${
                  isActive
                    ? "bg-white/10 text-white shadow-[0_0_18px_rgba(0,112,243,0.6)]"
                    : "text-slate-200/70 hover:bg-white/10 hover:text-white"
                }`
              }
            >
              {({ isActive }) => (
                <>
                  <span
                    className={`absolute left-0 top-2 h-6 w-1 rounded-full bg-transparent transition ${
                      collapsed ? "opacity-0" : ""
                    } ${
                      isActive
                        ? "bg-gradient-to-b from-[#0070f3] to-[#f59e0b] opacity-100"
                        : "opacity-0 group-hover:opacity-70"
                    }`}
                  />
                  {item.icon}
                  {!collapsed && <span>{item.label}</span>}
                </>
              )}
            </NavLink>
          ))}
      </nav>
    </aside>
  );
};
