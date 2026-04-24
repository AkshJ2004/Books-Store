'use client'

import React, { useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'

const Search = () => {
  const router = useRouter()
  const searchParams = useSearchParams()
  const [query, setQuery] = useState(searchParams.get('query') ?? '')

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    const params = new URLSearchParams()
    if (query) params.set('query', query)
    router.push(`/?${params.toString()}`)
  }

  return (
    <form onSubmit={handleSearch} className="flex items-center gap-2">
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search books..."
        className="border border-gray-300 rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#212a3b]"
      />
      <button
        type="submit"
        className="bg-[#212a3b] text-white px-4 py-2 rounded-lg text-sm hover:bg-[#2e3d55] transition-colors"
      >
        Search
      </button>
    </form>
  )
}

export default Search
