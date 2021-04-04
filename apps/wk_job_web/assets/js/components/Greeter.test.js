import { render, screen } from "@testing-library/react"
import Greeter from "./Greeter"

test("renders a greeter message", () => {
  render(<Greeter message="my message" />)

  const greeterElement = screen.getByText(/my message/i)
  expect(greeterElement).toBeInTheDocument()
  expect(greeterElement).toHaveClass("message")
})
