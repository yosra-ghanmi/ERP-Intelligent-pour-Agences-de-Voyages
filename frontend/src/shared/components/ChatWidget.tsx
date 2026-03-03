import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { MessageSquare, Send } from "lucide-react";
import { aiHttp } from "@/core/api/http";
import { Button } from "@/shared/ui/button";
import { Input } from "@/shared/ui/input";

type ChatMessage = { role: "user" | "assistant"; content: string };

export const ChatWidget = () => {
  const [open, setOpen] = useState(false);
  const [messages, setMessages] = useState<ChatMessage[]>([
    { role: "assistant", content: "How can I help with quotes or itineraries?" },
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);

  const send = async () => {
    if (!input.trim() || loading) return;
    const userMsg: ChatMessage = { role: "user", content: input.trim() };
    setMessages((m) => [...m, userMsg]);
    setInput("");
    setLoading(true);
    try {
      const res = await aiHttp.post("/chat", { messages: [...messages, userMsg] });
      const reply = res.data?.reply || res.data?.message || "Assistant response received.";
      setMessages((m) => [...m, { role: "assistant", content: reply }]);
    } catch {
      setMessages((m) => [...m, { role: "assistant", content: "AI server unavailable. Try again later." }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed bottom-6 right-6 z-50">
      <Button onClick={() => setOpen((v) => !v)} className="rounded-full shadow-soft" aria-label="Chat">
        <MessageSquare size={18} />
      </Button>
      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 20 }}
            className="mt-3 w-80 rounded-lg border border-border bg-card p-3 shadow-soft"
          >
            <div className="mb-2 text-sm font-semibold">AI Assistant</div>
            <div className="mb-2 h-64 space-y-2 overflow-auto rounded-md bg-background p-2 text-sm">
              {messages.map((m, idx) => (
                <div key={idx} className={m.role === "user" ? "text-right" : "text-left"}>
                  <span
                    className={`inline-block rounded-md px-2 py-1 ${
                      m.role === "user" ? "bg-primary text-primaryForeground" : "bg-accent"
                    }`}
                  >
                    {m.content}
                  </span>
                </div>
              ))}
            </div>
            <div className="flex gap-2">
              <Input value={input} onChange={(e) => setInput(e.target.value)} placeholder="Ask AI..." />
              <Button onClick={send} disabled={loading}>
                <Send size={16} />
              </Button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};
