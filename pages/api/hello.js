// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default async function handler(req, res) {
  const response = await fetch("https://jsonplaceholder.typicode.com/todos/1")
  const body = await response.json()
  res.status(200).json(body)
}
