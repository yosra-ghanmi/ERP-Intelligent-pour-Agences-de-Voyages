import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { useQuery } from "@tanstack/react-query";
import { jsPDF } from "jspdf";
import toast from "react-hot-toast";
import { bcHttp } from "@/core/api/http";
import { useAppStore } from "@/store/app";
import { Client, Quote, Service } from "@/types";
import { mockClients, mockQuotes, mockServices } from "@/utils/mock";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Button } from "@/shared/ui/button";
import { Table, TH, THead, TRow, TD } from "@/shared/ui/table";

export const QuotesPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);
  const selectQuote = useAppStore((s) => s.selectQuote);
  const selectedQuoteId = useAppStore((s) => s.selectedQuoteId);

  const { data: quotesData } = useQuery({
    queryKey: ["quotes"],
    queryFn: async () => (await bcHttp.get("/quotes")).data?.value as Quote[],
    initialData: demoMode ? mockQuotes : [],
    enabled: !demoMode,
  });

  const { data: clientsData } = useQuery({
    queryKey: ["clients"],
    queryFn: async () => (await bcHttp.get("/clients")).data?.value as Client[],
    initialData: demoMode ? mockClients : [],
    enabled: !demoMode,
  });

  const { data: servicesData } = useQuery({
    queryKey: ["services"],
    queryFn: async () => (await bcHttp.get("/services")).data?.value as Service[],
    initialData: demoMode ? mockServices : [],
    enabled: !demoMode,
  });

  const quotes = useMemo(() => quotesData || [], [quotesData]);
  const clients = useMemo(() => clientsData || [], [clientsData]);
  const services = useMemo(() => servicesData || [], [servicesData]);

  const selected = quotes.find((q) => q.id === selectedQuoteId) || quotes[0];

  const exportPdf = (quote?: Quote) => {
    if (!quote) return;
    const doc = new jsPDF();
    doc.setFontSize(16);
    doc.text("Travel Agency ERP - Quote", 20, 20);
    doc.setFontSize(12);
    doc.text(`Quote No: ${quote.quoteNo}`, 20, 30);
    doc.text(`Client: ${clients.find((c) => c.id === quote.clientId)?.name || ""}`, 20, 38);
    doc.text(`Date: ${quote.date}`, 20, 46);
    doc.text(`Valid Until: ${quote.validUntil}`, 20, 54);
    let y = 70;
    doc.text("Services:", 20, y);
    y += 8;
    quote.lines.forEach((line) => {
      const service = services.find((s) => s.id === line.serviceId)?.name || line.serviceId;
      doc.text(`${service} x${line.quantity} - $${line.lineAmount}`, 20, y);
      y += 8;
    });
    doc.text(`Total: $${quote.total}`, 20, y + 6);
    doc.save(`Quote-${quote.quoteNo}.pdf`);
  };

  const updateStatus = (quoteId: string, status: string) => {
    if (demoMode) return;
    bcHttp.post(`/quotes/${quoteId}/status`, { status });
  };

  const convertToInvoice = (quoteId: string) => {
    if (demoMode) return;
    bcHttp.post(`/quotes/${quoteId}/convert`);
  };

  const generateFromReservation = () => {
    if (demoMode) {
      toast.success("Quote generated from reservation");
      return;
    }
    bcHttp.post("/quotes/generate");
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>{t("quotes.title")}</div>
            <Button onClick={generateFromReservation}>{t("quotes.generateFromReservation")}</Button>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <THead>
              <TRow>
                <TH>{t("quotes.quoteNo")}</TH>
                <TH>{t("quotes.client")}</TH>
                <TH>{t("quotes.date")}</TH>
                <TH>{t("quotes.validUntil")}</TH>
                <TH>{t("quotes.status")}</TH>
                <TH>{t("common.actions")}</TH>
              </TRow>
            </THead>
            <tbody>
              {quotes.map((q) => (
                <TRow key={q.id}>
                  <TD>
                    <button onClick={() => selectQuote(q.id)} className="text-primary underline">
                      {q.quoteNo}
                    </button>
                  </TD>
                  <TD>{clients.find((c) => c.id === q.clientId)?.name}</TD>
                  <TD>{q.date}</TD>
                  <TD>{q.validUntil}</TD>
                  <TD>{q.status}</TD>
                  <TD className="space-x-2">
                    <Button variant="outline" onClick={() => updateStatus(q.id, "Sent")}>
                      {t("quotes.send")}
                    </Button>
                    <Button variant="outline" onClick={() => updateStatus(q.id, "Accepted")}>
                      {t("quotes.accept")}
                    </Button>
                    <Button variant="outline" onClick={() => updateStatus(q.id, "Rejected")}>
                      {t("quotes.reject")}
                    </Button>
                    <Button variant="secondary" onClick={() => convertToInvoice(q.id)}>
                      {t("quotes.convert")}
                    </Button>
                  </TD>
                </TRow>
              ))}
            </tbody>
          </Table>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>Quote Details</CardHeader>
        <CardContent>
          {selected ? (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="text-lg font-semibold">{selected.quoteNo}</div>
                <Button onClick={() => exportPdf(selected)}>{t("common.exportPdf")}</Button>
              </div>
              <Table>
                <THead>
                  <TRow>
                    <TH>Service</TH>
                    <TH>Qty</TH>
                    <TH>Unit Price</TH>
                    <TH>Line Amount</TH>
                  </TRow>
                </THead>
                <tbody>
                  {selected.lines.map((line) => (
                    <TRow key={line.id}>
                      <TD>{services.find((s) => s.id === line.serviceId)?.name}</TD>
                      <TD>{line.quantity}</TD>
                      <TD>${line.unitPrice}</TD>
                      <TD>${line.lineAmount}</TD>
                    </TRow>
                  ))}
                </tbody>
              </Table>
              <div className="text-right text-lg font-semibold">Total: ${selected.total}</div>
            </div>
          ) : (
            <div>No quote selected</div>
          )}
        </CardContent>
      </Card>
    </div>
  );
};
