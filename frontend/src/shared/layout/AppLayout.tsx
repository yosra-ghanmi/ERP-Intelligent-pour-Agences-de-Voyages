import { PropsWithChildren, useState } from "react";
import { Sidebar } from "@/shared/layout/Sidebar";
import { Navbar } from "@/shared/layout/Navbar";
import { ChatWidget } from "@/shared/components/ChatWidget";
import { Button } from "@/shared/ui/button";
import { PanelLeftClose, PanelLeftOpen } from "lucide-react";

export const AppLayout = ({ children }: PropsWithChildren) => {
  const [collapsed, setCollapsed] = useState(false);
  return (
    <div className="relative h-full bg-background">
      <Sidebar collapsed={collapsed} />
      <div
        className={`fixed top-0 z-[50] flex h-16 items-center justify-between border-b border-[#0070f3]/30 bg-[var(--sidebar-bg)] px-6 text-white ${
          collapsed ? "left-20 right-0" : "left-64 right-0"
        }`}
      >
        <Button variant="ghost" onClick={() => setCollapsed((v) => !v)} className="text-white hover:bg-white/10">
          {collapsed ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
        </Button>
        <Navbar />
      </div>
      <main
        className={`min-h-full bg-background px-6 pb-8 pt-24 page-fade-in ${
          collapsed ? "pl-20" : "pl-64"
        }`}
      >
        {children}
      </main>
      <ChatWidget />
    </div>
  );
};
