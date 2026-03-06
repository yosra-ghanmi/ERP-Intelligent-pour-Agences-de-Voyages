export type Role = "Admin" | "TravelAgent" | "Accountant";

export type User = {
  email: string;
  password: string;
  role: Role;
};

export type ReservationStatus = "Pending" | "Program Designed" | "Confirmed" | "Cancelled";
export type QuoteStatus = "Draft" | "Sent" | "Accepted" | "Rejected" | "Expired";
export type InvoiceStatus = "Open" | "Partial" | "Paid" | "Overdue";

export type Service = {
  id: string;
  name: string;
  type: "Hotel" | "Flight" | "Tour" | "Activity";
  location: string;
  price: number;
  latitude: number;
  longitude: number;
};

export type Client = {
  id: string;
  name: string;
  email: string;
  phone: string;
  preference: string;
};

export type Reservation = {
  id: string;
  clientId: string;
  serviceId: string;
  startDate: string;
  endDate: string;
  status: ReservationStatus;
};

export type QuoteLine = {
  id: string;
  serviceId: string;
  quantity: number;
  unitPrice: number;
  lineAmount: number;
};

export type Quote = {
  id: string;
  quoteNo: string;
  clientId: string;
  date: string;
  validUntil: string;
  status: QuoteStatus;
  lines: QuoteLine[];
  total: number;
};

export type Invoice = {
  id: string;
  invoiceNo: string;
  quoteNo: string;
  status: InvoiceStatus;
  total: number;
  balance: number;
};

export type Payment = {
  id: string;
  invoiceNo: string;
  amount: number;
  method: "Cash" | "Bank Transfer" | "Credit Card" | "Check";
  date: string;
};

export type ItineraryDay = {
  day: number;
  items: { time?: string; title: string; tips?: string }[];
};

export type Itinerary = {
  summary: string;
  days: ItineraryDay[];
};
