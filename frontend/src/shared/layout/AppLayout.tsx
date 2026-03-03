import { PropsWithChildren, useState } from "react";
import { Sidebar } from "@/shared/layout/Sidebar";
import { Navbar } from "@/shared/layout/Navbar";
import { ChatWidget } from "@/shared/components/ChatWidget";
import { Button } from "@/shared/ui/button";
import { PanelLeftClose, PanelLeftOpen } from "lucide-react";

export const AppLayout = ({ children }: PropsWithChildren) => {
  const [collapsed, setCollapsed] = useState(false);
  return (
    <div className="flex h-full">
      <Sidebar collapsed={collapsed} />
      <div className="flex min-w-0 flex-1 flex-col">
        <div className="flex items-center justify-between border-b border-border px-6 py-2">
          <Button variant="ghost" onClick={() => setCollapsed((v) => !v)}>
            {collapsed ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
          </Button>
          <Navbar />
        </div>
        <main className="flex-1 overflow-auto bg-background px-6 py-6">{children}</main>
      </div>
      <ChatWidget />
    </div>
  );
};
