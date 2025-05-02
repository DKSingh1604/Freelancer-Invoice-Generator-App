// import { serve } from "jsr:@supabase/functions";
// import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";
// import { Resend } from "jsr:@resend/sdk@1.2.0";

// serve(async (req) => {
//   const { pdfUrl, userEmail, clientEmail } = await req.json();

// //   Get secrets
//   const SUPABASE_URL = globalThis.SUPABASE_URL as string;
//   const SUPABASE_SERVICE_ROLE_KEY = globalThis.SUPABASE_SERVICE_ROLE_KEY as string;
//   const RESEND_API_KEY = globalThis.RESEND_API_KEY as string;

//   const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

//   const filePath = pdfUrl.split("invoices/").pop() ?? "";
//   const { data, error } = await supabase.storage.from("invoices").download(filePath);

//   if (error || !data) {
//     return new Response(JSON.stringify({ error: "Failed to download PDF" }), { status: 400 });
//   }

//   // Convert ArrayBuffer to base64
//   const pdfBuffer = await data.arrayBuffer();
//   const base64 = btoa(String.fromCharCode(...new Uint8Array(pdfBuffer)));

//   const resend = new Resend(RESEND_API_KEY);
//   await resend.emails.send({
//     from: "Your App <noreply@yourdomain.com>",
//     to: [userEmail, clientEmail],
//     subject: "Your Invoice",
//     html: "<p>Attached is your invoice PDF.</p>",
//     attachments: [
//       {
//         filename: "invoice.pdf",
//         content: base64,
//       },
//     ],
//   });

//   return new Response(JSON.stringify({ success: true }), { status: 200 });
// });