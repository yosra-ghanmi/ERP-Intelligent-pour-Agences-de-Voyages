import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useNavigate } from "react-router-dom";
import { Input } from "@/shared/ui/input";
import { Button } from "@/shared/ui/button";
import { Select } from "@/shared/ui/select";
import { useAuthStore } from "@/store/auth";
import { users } from "@/utils/mockUsers";

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(4),
  role: z.enum(["Admin", "TravelAgent", "Accountant"]),
});

type FormValues = z.infer<typeof schema>;

export const LoginPage = () => {
  const navigate = useNavigate();
  const signIn = useAuthStore((s) => s.signIn);
  const {
    register,
    handleSubmit,
    formState: { isSubmitting },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { role: "TravelAgent" },
  });

  const onSubmit = (values: FormValues) => {
    const user = users.find((u) => u.email === values.email && u.password === values.password && u.role === values.role);
    if (user) {
      signIn("demo-token", values.role, values.email);
      navigate("/");
    } else {
      alert("Invalid credentials");
    }
  };

  return (
    <div className="flex h-full items-center justify-center bg-background">
      <div className="w-full max-w-md rounded-lg border border-border bg-card p-8 shadow-soft">
        <div className="mb-6 text-2xl font-semibold">Travel ERP</div>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <Input placeholder="Email" {...register("email")} />
          <Input placeholder="Password" type="password" {...register("password")} />
          <Select {...register("role")}>
            <option value="Admin">Admin</option>
            <option value="TravelAgent">TravelAgent</option>
            <option value="Accountant">Accountant</option>
          </Select>
          <Button type="submit" disabled={isSubmitting} className="w-full">
            Sign In
          </Button>
        </form>
        <div className="mt-6">
          <h3 className="text-lg font-semibold">Demo Users</h3>
          <ul className="mt-2 space-y-2">
            {users.map((user) => (
              <li key={user.email} className="text-sm">
                <b>{user.role}:</b> {user.email} / {user.password}
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};
