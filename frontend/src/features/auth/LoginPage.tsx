import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useNavigate } from "react-router-dom";
import { Input } from "@/shared/ui/input";
import { Button } from "@/shared/ui/button";
import { useAuthStore } from "@/store/auth";
import { AnimatePresence, motion } from "framer-motion";
import logo from "@/assets/logo.png"; 

// 1. تحديث الـ Schema لزيادة حقل الـ Role
const schema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(4, "Password must be at least 4 characters"),
  fullName: z.string().min(3, "Full name required").optional(),
  role: z.enum(["Admin", "TravelAgent", "Accountant"], {
    errorMap: () => ({ message: "Please select a role" }),
  }),
});

type FormValues = z.infer<typeof schema>;

export const LoginPage = () => {
  const navigate = useNavigate();
  const signIn = useAuthStore((s) => s.signIn);
  const [mode, setMode] = useState<"signin" | "signup">("signin");

  const {
    register,
    handleSubmit,
    formState: { isSubmitting, errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { role: "TravelAgent" },
  });

  const onSubmit = (values: FormValues) => {
    signIn("demo-token", values.role, values.email);
    switch (values.role) {
      case "Admin":
        navigate("/admin");
        break;
      case "Accountant":
        navigate("/finance");
        break;
      default:
        navigate("/agent");
        break;
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-[#f8fafc] px-6 py-10 font-sans">
      <div className="relative w-full max-w-5xl min-h-[600px] overflow-hidden rounded-[40px] border border-white bg-white/70 shadow-[0_32px_64px_-12px_rgba(0,0,0,0.14)] backdrop-blur-xl">
        
        <div className="pointer-events-none absolute inset-0 opacity-40">
          <div className="h-full w-full bg-[radial-gradient(circle_at_20%_20%,#0ea5e922,transparent_45%),radial-gradient(circle_at_80%_10%,#1e3a8a11,transparent_40%)]" />
          <div className="absolute inset-0 bg-[linear-gradient(30deg,#f1f5f9_0.5px,transparent_0.5px),linear-gradient(150deg,#f1f5f9_0.5px,transparent_0.5px)] bg-[length:100px_100px]" />
        </div>

        <div className="relative z-10 flex h-full items-center justify-center px-6 py-10">
          <div className="w-full max-w-md">
            
            <div className="mb-6 flex flex-col items-center text-center">
              <motion.img 
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                src={logo} 
                alt="Travel Agency ERP" 
                className="h-32 w-auto object-contain drop-shadow-2xl" 
              />
              <div className="mt-4">
                <h1 className="text-2xl font-black tracking-tighter text-[#1E3A8A]">
                  TRAVEL AGENCY <span className="text-[#06B6D4]">ERP</span>
                </h1>
                <p className="mt-2 text-[10px] font-bold uppercase tracking-[4px] text-slate-400">
                  Premium Travel Workspace
                </p>
              </div>
            </div>

            <div className="mb-5 flex items-center justify-center gap-2 rounded-2xl border border-slate-100 bg-slate-50/50 p-1.5">
              <button
                type="button"
                onClick={() => setMode("signin")}
                className={`w-1/2 rounded-xl px-4 py-2.5 text-sm font-bold transition-all duration-300 ${
                  mode === "signin" ? "bg-white text-[#1E3A8A] shadow-md" : "text-slate-500 hover:bg-white/50"
                }`}
              >
                Sign In
              </button>
              <button
                type="button"
                onClick={() => setMode("signup")}
                className={`w-1/2 rounded-xl px-4 py-2.5 text-sm font-bold transition-all duration-300 ${
                  mode === "signup" ? "bg-white text-[#1E3A8A] shadow-md" : "text-slate-500 hover:bg-white/50"
                }`}
              >
                Sign Up
              </button>
            </div>
            
            <AnimatePresence mode="wait">
              <motion.form
                key={mode}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.2 }}
                onSubmit={handleSubmit(onSubmit)}
                className="space-y-4"
              >
                {mode === "signup" && (
                  <Input
                    placeholder="Full Name"
                    className="h-11 rounded-2xl border-slate-100 bg-white px-5 shadow-sm"
                    {...register("fullName")}
                  />
                )}

                <Input
                  placeholder="Email Address"
                  className="h-11 rounded-2xl border-slate-100 bg-white px-5 shadow-sm"
                  {...register("email")}
                />

                <Input
                  placeholder="Password"
                  type="password"
                  className="h-11 rounded-2xl border-slate-100 bg-white px-5 shadow-sm"
                  {...register("password")}
                />

                <div className="relative">
                  <select
                    {...register("role")}
                    className="w-full h-11 rounded-2xl border border-slate-100 bg-white px-5 text-sm text-slate-600 outline-none appearance-none cursor-pointer focus:ring-2 focus:ring-[#06B6D4]/20 shadow-sm"
                  >
                    <option value="Admin">Administrator (Admin)</option>
                    <option value="TravelAgent">Travel Agent (Agency)</option>
                    <option value="Accountant">Financial Accountant</option>
                  </select>
                  <div className="pointer-events-none absolute right-4 top-1/2 -translate-y-1/2 text-slate-400">
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7" />
                    </svg>
                  </div>
                </div>

                <Button
                  type="submit"
                  disabled={isSubmitting}
                  className="h-12 w-full rounded-2xl bg-gradient-to-r from-[#1E3A8A] to-[#06B6D4] text-sm font-bold text-white shadow-lg transition-all hover:scale-[1.02]"
                >
                  {isSubmitting ? "Processing..." : mode === "signup" ? "CREATE ACCOUNT" : "SIGN IN"}
                </Button>

                <div className="pt-1 text-center">
                  <p className="text-[9px] font-bold uppercase tracking-[3px] text-slate-300">
                    Travel Agency ERP &copy; 2026
                  </p>
                </div>
              </motion.form>
            </AnimatePresence>
          </div>
        </div>
      </div>
    </div>
  );
};
