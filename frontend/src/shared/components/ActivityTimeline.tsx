import { Card, CardContent, CardHeader } from "@/shared/ui/card";

const activity = [
  { id: "A1", title: "Quote sent", time: "2h ago" },
  { id: "A2", title: "Invoice created", time: "1h ago" },
  { id: "A3", title: "Payment registered", time: "30m ago" },
];

export const ActivityTimeline = () => {
  return (
    <Card>
      <CardHeader>
        <div className="text-sm font-semibold">Activity History</div>
      </CardHeader>
      <CardContent className="space-y-3">
        {activity.map((item) => (
          <div key={item.id} className="flex items-center justify-between rounded-md border border-border px-3 py-2">
            <div className="text-sm">{item.title}</div>
            <div className="text-xs text-mutedForeground">{item.time}</div>
          </div>
        ))}
      </CardContent>
    </Card>
  );
};
