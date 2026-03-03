import { useTranslation } from "react-i18next";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { LineChart, Line, XAxis, YAxis, Tooltip, PieChart, Pie, Cell, BarChart, Bar, Legend } from "recharts";
import { ActivityTimeline } from "@/shared/components/ActivityTimeline";
import { AuditTimeline } from "@/shared/components/AuditTimeline";

const revenueData = [
  { month: "Jan", value: 12000 },
  { month: "Feb", value: 18000 },
  { month: "Mar", value: 24000 },
  { month: "Apr", value: 21000 },
  { month: "May", value: 32000 },
];

const reservationStatusData = [
  { name: "Pending", value: 12 },
  { name: "Confirmed", value: 24 },
  { name: "Cancelled", value: 3 },
];

const serviceData = [
  { name: "Hotel", value: 14 },
  { name: "Flight", value: 9 },
  { name: "Tour", value: 7 },
  { name: "Activity", value: 4 },
];

const funnelData = [
  { stage: "Draft", value: 60 },
  { stage: "Sent", value: 40 },
  { stage: "Accepted", value: 22 },
  { stage: "Invoiced", value: 18 },
];

const colors = ["#4f46e5", "#10b981", "#f59e0b", "#ef4444"];

export const DashboardPage = () => {
  const { t } = useTranslation();
  return (
    <div className="space-y-6">
      <div className="grid gap-4 md:grid-cols-5">
        <Card>
          <CardHeader>{t("dashboard.monthlyRevenue")}</CardHeader>
          <CardContent className="text-2xl font-semibold">$32,000</CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.topDestination")}</CardHeader>
          <CardContent className="text-2xl font-semibold">Tunis</CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.conversionRate")}</CardHeader>
          <CardContent className="text-2xl font-semibold">44%</CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.totalReservations")}</CardHeader>
          <CardContent className="text-2xl font-semibold">39</CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.overdueInvoices")}</CardHeader>
          <CardContent className="text-2xl font-semibold">3</CardContent>
        </Card>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>{t("dashboard.revenueByMonth")}</CardHeader>
          <CardContent>
            <LineChart width={520} height={260} data={revenueData}>
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="value" stroke="#4f46e5" strokeWidth={2} />
            </LineChart>
          </CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.reservationsByStatus")}</CardHeader>
          <CardContent className="flex justify-center">
            <PieChart width={260} height={260}>
              <Pie data={reservationStatusData} dataKey="value" nameKey="name" outerRadius={100}>
                {reservationStatusData.map((_, index) => (
                  <Cell key={index} fill={colors[index % colors.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.topServices")}</CardHeader>
          <CardContent>
            <BarChart width={520} height={260} data={serviceData}>
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="value" fill="#10b981" />
            </BarChart>
          </CardContent>
        </Card>
        <Card>
          <CardHeader>{t("dashboard.quoteFunnel")}</CardHeader>
          <CardContent>
            <BarChart width={520} height={260} data={funnelData} layout="vertical">
              <XAxis type="number" />
              <YAxis type="category" dataKey="stage" />
              <Tooltip />
              <Bar dataKey="value" fill="#4f46e5" />
            </BarChart>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <ActivityTimeline />
        <AuditTimeline />
      </div>
    </div>
  );
};
