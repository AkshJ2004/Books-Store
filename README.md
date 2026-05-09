<div align="center">

# 📚 Bookified

### *Transform your books into interactive AI voice conversations*

[![Next.js](https://img.shields.io/badge/Next.js-16.2-black?style=for-the-badge&logo=next.js)](https://nextjs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue?style=for-the-badge&logo=typescript)](https://typescriptlang.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-Mongoose-green?style=for-the-badge&logo=mongodb)](https://mongodb.com)
[![Clerk](https://img.shields.io/badge/Auth-Clerk-purple?style=for-the-badge)](https://clerk.com)
[![Vercel](https://img.shields.io/badge/Deploy-Vercel-black?style=for-the-badge&logo=vercel)](https://vercel.com)

[🚀 Live Demo](https://books-store-eight-delta.vercel.app/) · [🐛 Report Bug](../../issues) · [✨ Request Feature](../../issues)

---

</div>

## ✨ What is Bookified?

**Bookified** is a full-stack web app that lets you **upload any PDF book** and instantly have a **voice conversation with an AI** that knows its contents inside and out. Think of it as giving your bookshelf a voice.

> Upload → Process → Talk. That's it.

---

## 🎬 How It Works

```
┌─────────────┐     ┌──────────────┐     ┌────────────────┐     ┌──────────────┐
│  Upload PDF  │────▶│ AI Processes │────▶│  Segments Live │────▶│  Voice Chat  │
│   + Cover   │     │  & Indexes   │     │   in MongoDB   │     │  via VAPI    │
└─────────────┘     └──────────────┘     └────────────────┘     └──────────────┘
```

1. **Upload** your PDF (up to 50MB) and optionally a cover image
2. **Processing** — the app extracts text, chunks it into searchable segments, and stores them
3. **Talk** — hit the mic button and have a real voice conversation with an AI that can answer questions about your book in real time

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Next.js 16 (App Router) |
| **Language** | TypeScript |
| **Styling** | Tailwind CSS v4 + shadcn/ui |
| **Auth** | Clerk (with billing/subscription tiers) |
| **Database** | MongoDB + Mongoose |
| **File Storage** | Vercel Blob |
| **Voice AI** | VAPI (ElevenLabs voices) |
| **PDF Parsing** | pdfjs-dist (client-side) |
| **Forms** | React Hook Form + Zod |
| **CI/CD** | Azure Pipelines |

---

## 🚀 Getting Started

### Prerequisites

- Node.js **≥ 20.9.0**
- MongoDB instance (local or Atlas)
- Accounts for: [Clerk](https://clerk.com), [Vercel](https://vercel.com), [VAPI](https://vapi.ai)

### 1. Clone & Install

```bash
git clone https://github.com/your-username/bookified.git
cd bookified
npm install
```

### 2. Environment Variables

Create a `.env.local` file in the root:

```env
# MongoDB
MONGODB_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/bookified

# Clerk Auth
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# Vercel Blob Storage
BLOB_READ_WRITE_TOKEN=vercel_blob_rw_...

# VAPI Voice AI
NEXT_PUBLIC_VAPI_API_KEY=...
NEXT_PUBLIC_ASSISTANT_ID=...
```

### 3. Run Locally

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) — you're live. 🎉

---

## 📁 Project Structure

```
bookified/
├── app/
│   ├── (root)/
│   │   ├── page.tsx              # Library / homepage
│   │   ├── books/new/page.tsx    # Upload a new book
│   │   └── subscriptions/page.tsx
│   ├── api/
│   │   ├── upload/route.ts       # Vercel Blob upload handler
│   │   └── vapi/search-book/    # VAPI tool endpoint (RAG search)
│   ├── books/[slug]/page.tsx     # Book detail + voice chat page
│   └── layout.tsx
│
├── components/
│   ├── VapiControls.tsx          # Main voice interaction UI
│   ├── UploadForm.tsx            # PDF + metadata upload form
│   ├── Transcript.tsx            # Live conversation transcript
│   ├── FileUploader.tsx          # Drag-and-drop file input
│   └── ...
│
├── database/
│   ├── models/
│   │   ├── book.model.ts
│   │   ├── book-segment.model.ts
│   │   └── voice-session.model.ts
│   └── mongoose.ts               # Connection with caching
│
├── hooks/
│   ├── useVapi.ts                # VAPI SDK lifecycle hook
│   └── useSubscription.ts        # Clerk plan detection
│
├── lib/
│   ├── actions/
│   │   ├── book.actions.ts       # Server actions: CRUD + search
│   │   └── session.actions.ts    # Session tracking
│   ├── constants.ts              # Voice options, limits, etc.
│   ├── subscription-constants.ts # Plan tiers and limits
│   └── utils.ts                  # PDF parsing, slug gen, etc.
│
└── types.d.ts                    # Global TypeScript types
```

---

## 🎙️ Voice & AI Architecture

Bookified uses **retrieval-augmented generation (RAG)** to give the AI context from your book:

```
User speaks
    │
    ▼
VAPI Assistant (configured in VAPI dashboard)
    │
    ├── Calls tool: searchBook(bookId, query)
    │       │
    │       ▼
    │   /api/vapi/search-book
    │       │
    │       ▼
    │   MongoDB Text Search → Top 3 matching segments
    │       │
    │       ▼
    │   Returns combined text back to VAPI
    │
    ▼
AI responds with grounded, book-specific answers
```

### Available Voices

| Name | Style | Gender |
|------|-------|--------|
| Dave | Casual, British-Essex | Male |
| Daniel | Authoritative, warm, British | Male |
| Chris | Easy-going | Male |
| Rachel | Calm, clear, American | Female |
| Sarah | Soft, approachable, American | Female |

---

## 💳 Subscription Tiers

Managed via **Clerk Billing**:

| Feature | Free | Standard | Pro |
|---------|------|----------|-----|
| Books | 1 | 10 | 100 |
| Sessions / month | 5 | 100 | Unlimited |
| Max session length | 5 min | 15 min | 60 min |
| Session history | ❌ | ✅ | ✅ |

---

## 🚢 Deployment

### Vercel (Recommended)

```bash
# One-click deploy
vercel deploy
```

Set all environment variables in your Vercel project dashboard.

### Azure App Service (via Azure Pipelines)

The repo includes `azure-pipelines.yml` with a full CI/CD pipeline:

- **Lint + TypeScript check** on every push
- **Build** on success
- **Deploy to Staging** on `develop` branch
- **Deploy to Production** on `main` branch

```yaml
# Targets:
# Staging:    bookified-staging   (Node 22 LTS)
# Production: bookified-prod-aksh (Node 22 LTS)
```

---

## 🧠 Key Implementation Details

### PDF Processing (Client-Side)
Text extraction and cover generation happen **in the browser** using `pdfjs-dist` — no server needed for parsing.

### Segment Indexing
Books are chunked into ~500-word segments with 50-word overlap for context continuity. MongoDB's **text index** powers fast search; a regex fallback catches edge cases.

### Session Tracking
Every voice session is recorded with start/end times and duration, enabling monthly usage enforcement per plan.

### Error Serialization
Next.js server actions require serializable return values. All `catch` blocks serialize errors with:
```ts
error: e instanceof Error ? e.message : "Unknown error"
```

---

## 📝 Scripts

```bash
npm run dev      # Start development server
npm run build    # Production build
npm run start    # Start production server
npm run lint     # Run ESLint
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request



<div align="center">

Built with ❤️ 

⭐ Star this repo if you found it useful!

</div>
