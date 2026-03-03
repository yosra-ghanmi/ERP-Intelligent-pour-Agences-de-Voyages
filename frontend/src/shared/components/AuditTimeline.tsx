import { Card, CardContent, CardHeader } from "@/shared/ui/card";

const audit = [
  { id: "L1", actor: "System", action: "Status changed to Sent", time: "2026-02-12 10:30" },
  { id: "L2", actor: "Agent", action: "Quote accepted", time: "2026-02-12 11:00" },
  { id: "L3", actor: "Accountant", action: "Invoice created", time: "2026-02-12 12:15" },
];

export const AuditTimeline = () => {
  return (
    <Card>
      <CardHeader>
        <div className="text-sm font-semibold">Audit Log</div>
      </CardHeader>
      <CardContent className="space-y-3">
        {audit.map((item) => (
          <div key={item.id} className="rounded-md border border-border px-3 py-2">
            <div className="text-sm">{item.action}</div>
            <div className="text-xs text-mutedForeground">
              {item.actor} • {item.time}
            </div>
          </div>
        ))}
      </CardContent>
    </Card>
  );
};
