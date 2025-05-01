// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { Resend } from "npm:resend";

console.log("Hello from Functions!")

Deno.serve(async (req) => {
  try {
    const { pdfUrl, userEmail, clientEmail } = await req.json();

    if (!pdfUrl || !userEmail || !clientEmail) {
      return new Response(
        JSON.stringify({ error: "Missing required fields." }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Initialize Supabase client with service role key
    const supabase = createClient(
      Deno.env.get("https://ywvkjuzgivydytapezbp.supabase.co")!,
      Deno.env.get("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dmtqdXpnaXZ5ZHl0YXBlemJwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTY1NTE4NiwiZXhwIjoyMDYxMjMxMTg2fQ.ECIQfXO9vjnFOKV899GvqW9bULjYdDhbZFzGiAbvlk4")!
    );

    // Extract the file path from the URL (assuming 'invoices/' bucket)
    const filePath = pdfUrl.split("invoices/").pop() ?? "";

    // Download the PDF from Supabase Storage
    const { data, error } = await supabase.storage
      .from("invoices")
      .download(filePath);

    if (error || !data) {
      return new Response(
        JSON.stringify({ error: "Failed to download PDF from storage." }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Read the PDF as a buffer
    const pdfBuffer = await data.arrayBuffer();

    // Send the email using Resend
    const resend = new Resend(Deno.env.get("RESEND_API_KEY")!);
    await resend.emails.send({
      from: "Your App <noreply@yourdomain.com>",
      to: [userEmail, clientEmail],
      subject: "Your Invoice",
      html: "<p>Attached is your invoice PDF.</p>",
      attachments: [
        {
          filename: "invoice.pdf",
          content: Buffer.from(pdfBuffer).toString("base64"),
        },
      ],
    });

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: e.message || "Unknown error" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/send_invoice_email' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
