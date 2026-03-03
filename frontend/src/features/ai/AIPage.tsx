import { useState } from "react";
import { useTranslation } from "react-i18next";
import { jsPDF } from "jspdf";
import { aiHttp } from "@/core/api/http";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Button } from "@/shared/ui/button";
import { Itinerary } from "@/types";

const emptyItinerary: Itinerary = {
  summary: "No itinerary generated.",
  days: [],
};

export const AIPage = () => {
  const { t } = useTranslation();
  const [itinerary, setItinerary] = useState<Itinerary>(emptyItinerary);
  const [loading, setLoading] = useState(false);

  const generate = async () => {
    setLoading(true);
    try {
      const res = await aiHttp.post("/generate", { days: 3 });
      setItinerary(res.data as Itinerary);
    } catch {
      setItinerary({
        summary: "AI server unavailable.",
        days: [],
      });
    } finally {
      setLoading(false);
    }
  };

  const downloadPdf = () => {
    const doc = new jsPDF();
    doc.setFontSize(16);
    doc.text("AI Itinerary", 20, 20);
    doc.setFontSize(12);
    doc.text(itinerary.summary || "", 20, 30);
    let y = 45;
    itinerary.days.forEach((d) => {
      doc.text(`Day ${d.day}`, 20, y);
      y += 8;
      d.items.forEach((item) => {
        doc.text(`- ${item.time ? item.time + " " : ""}${item.title}`, 24, y);
        y += 6;
      });
      y += 6;
    });
    doc.save("itinerary.pdf");
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>{t("ai.title")}</CardHeader>
        <CardContent className="flex gap-3">
          <Button onClick={generate} disabled={loading}>
            {t("ai.generate")}
          </Button>
          <Button variant="secondary" onClick={downloadPdf}>
            {t("ai.download")}
          </Button>
          <Button variant="outline">{t("ai.save")}</Button>
        </CardContent>
      </Card>
      <div className="grid gap-4 md:grid-cols-3">
        {itinerary.days.map((d) => (
          <Card key={d.day}>
            <CardHeader>Day {d.day}</CardHeader>
            <CardContent className="space-y-2">
              {d.items.map((item, idx) => (
                <div key={idx} className="rounded-md border border-border p-2">
                  <div className="text-sm font-medium">
                    {item.time ? `${item.time} ` : ""}
                    {item.title}
                  </div>
                  {item.tips && <div className="text-xs text-mutedForeground">{item.tips}</div>}
                </div>
              ))}
            </CardContent>
          </Card>
        ))}
      </div>
      {itinerary.days.length === 0 && (
        <Card>
          <CardContent>{itinerary.summary}</CardContent>
        </Card>
      )}
    </div>
  );
};
