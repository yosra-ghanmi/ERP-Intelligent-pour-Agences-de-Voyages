import { PropsWithChildren, useState } from "react";
import { NavLink, Outlet } from "react-router-dom";
import { Button } from "@/shared/ui/button";
import { Navbar } from "@/shared/layout/Navbar";
import { ChatWidget } from "@/shared/components/ChatWidget";
import { PanelLeftClose, PanelLeftOpen } from "lucide-react";
import logo from "@/assets/logo.png";

type NavItem = {
  to: string;
  label: string;
  icon: React.ReactNode;
};

export const RoleLayout = ({
  children,
  navItems,
  brandLabel,
}: PropsWithChildren<{ navItems: NavItem[]; brandLabel: string }>) => {
  const [collapsed, setCollapsed] = useState(false);
  return (
    <div className="relative h-full bg-background">
      <aside
        className={`fixed left-0 top-0 z-[50] h-full border-r border-[#0f2748] bg-[#1a365d] ${
          collapsed ? "w-20" : "w-64"
        } transition-all`}
      >
        <div className="flex items-center gap-3 px-4 py-6">
          <img src={logo} alt={brandLabel} className="h-11 w-11 rounded-full object-contain" />
          {!collapsed && <div className="text-sm font-semibold tracking-wide text-white">{brandLabel}</div>}
        </div>
        <nav className="flex flex-col gap-2 px-3 pb-6">
          {navItems.map((item) => (
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
                    } ${isActive ? "bg-gradient-to-b from-[#0070f3] to-[#f59e0b] opacity-100" : "opacity-0"}`}
                  />
                  {item.icon}
                  {!collapsed && <span>{item.label}</span>}
                </>
              )}
            </NavLink>
          ))}
        </nav>
      </aside>
      <div
        className={`fixed top-0 z-[50] flex h-16 items-center justify-between border-b border-white/40 bg-white/70 px-6 text-slate-900 backdrop-blur-xl ${
          collapsed ? "left-20 right-0" : "left-64 right-0"
        }`}
      >
        <Button variant="ghost" onClick={() => setCollapsed((v) => !v)} className="text-slate-900 hover:bg-slate-900/10">
          {collapsed ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
        </Button>
        <Navbar />
      </div>
      <main
        className={`min-h-full bg-background px-6 pb-8 pt-24 page-fade-in ${
          collapsed ? "pl-20" : "pl-64"
        }`}
      >
        {children ?? <Outlet />}
      </main>
      <ChatWidget />
    </div>
  );
};
