import { Bell } from "lucide-react";
import { useState } from "react";
import { Card, CardContent } from "@/shared/ui/card";

const notifications = [
  { id: "N1", title: "Quote accepted", body: "QT-002 was accepted." },
  { id: "N2", title: "Invoice overdue", body: "INV-004 is overdue." },
  { id: "N3", title: "Payment received", body: "Payment received for INV-001." },
];

export const NotificationCenter = () => {
  const [open, setOpen] = useState(false);
  return (
    <div className="relative">
      <button onClick={() => setOpen((v) => !v)} className="rounded-md p-2 hover:bg-accent">
        <Bell size={18} />
      </button>
      {open && (
        <div className="absolute right-0 top-10 w-72">
          <Card>
            <CardContent className="space-y-3">
              {notifications.map((n) => (
                <div key={n.id} className="rounded-md border border-border p-2">
                  <div className="text-sm font-medium">{n.title}</div>
                  <div className="text-xs text-mutedForeground">{n.body}</div>
                </div>
              ))}
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
};
