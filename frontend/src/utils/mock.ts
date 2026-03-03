import { Client, Invoice, Payment, Quote, Reservation, Service } from "@/types";

export const mockServices: Service[] = [
  { id: "SVC-001", name: "Hilton Tunis", type: "Hotel", location: "Tunis", price: 250, latitude: 36.8065, longitude: 10.1815 },
  { id: "SVC-002", name: "Tunis-Paris", type: "Flight", location: "Paris", price: 450, latitude: 48.8566, longitude: 2.3522 },
  { id: "SVC-003", name: "Sahara Adventure", type: "Tour", location: "Douz", price: 520, latitude: 33.456, longitude: 9.021 },
  { id: "SVC-004", name: "Djerba Explore", type: "Activity", location: "Djerba", price: 120, latitude: 33.808, longitude: 10.991 },
];

export const mockClients: Client[] = [
  { id: "CL-001", name: "John Doe", email: "john@email.com", phone: "+216 12 345 678", preference: "Luxury" },
  { id: "CL-002", name: "Sarah Mansour", email: "sarah@email.com", phone: "+216 55 000 222", preference: "Adventure" },
  { id: "CL-003", name: "Yassine Jlassi", email: "yassine@email.com", phone: "+216 93 777 111", preference: "Relaxation" },
];

export const mockReservations: Reservation[] = [
  { id: "RES-001", clientId: "CL-001", serviceId: "SVC-001", startDate: "2026-02-14", endDate: "2026-02-16", status: "Pending" },
  { id: "RES-002", clientId: "CL-002", serviceId: "SVC-003", startDate: "2026-02-18", endDate: "2026-02-20", status: "Program Designed" },
  { id: "RES-003", clientId: "CL-003", serviceId: "SVC-004", startDate: "2026-02-21", endDate: "2026-02-23", status: "Confirmed" },
];

export const mockQuotes: Quote[] = [
  {
    id: "QT-001",
    quoteNo: "QT-001",
    clientId: "CL-001",
    date: "2026-02-10",
    validUntil: "2026-03-10",
    status: "Sent",
    lines: [
      { id: "QL-001", serviceId: "SVC-001", quantity: 2, unitPrice: 250, lineAmount: 500 },
      { id: "QL-002", serviceId: "SVC-002", quantity: 1, unitPrice: 450, lineAmount: 450 },
    ],
    total: 950,
  },
  {
    id: "QT-002",
    quoteNo: "QT-002",
    clientId: "CL-002",
    date: "2026-02-12",
    validUntil: "2026-03-12",
    status: "Accepted",
    lines: [{ id: "QL-003", serviceId: "SVC-003", quantity: 1, unitPrice: 520, lineAmount: 520 }],
    total: 520,
  },
];

export const mockInvoices: Invoice[] = [
  { id: "INV-001", invoiceNo: "INV-001", quoteNo: "QT-002", status: "Open", total: 520, balance: 520 },
  { id: "INV-002", invoiceNo: "INV-002", quoteNo: "QT-001", status: "Partial", total: 950, balance: 350 },
];

export const mockPayments: Payment[] = [
  { id: "PAY-001", invoiceNo: "INV-002", amount: 600, method: "Bank Transfer", date: "2026-02-15" },
];
