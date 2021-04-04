import { render, screen } from "@testing-library/react"
import ListTitle from "./ListTitle"

test("renders a list title", () => {
  render(<ListTitle title="my title" count={13} />)

  const titleElement = screen.getByText(/my title/i)
  expect(titleElement).toBeInTheDocument()
  expect(titleElement).toHaveClass("list-title")

  const countElement = screen.getByText(/13/i)
  expect(countElement).toBeInTheDocument()
  expect(countElement).toHaveClass("list-count")
})
