import { render, screen } from "@testing-library/react"
import Applicant from "./Applicant"

test("renders a applicant", () => {
  render(
    <Applicant
      id="my-id"
      name="my name"
      description="my description"
      thumb="/my/thumb/url"
    />
  )

  const nameElement = screen.getByText(/my name/i)
  expect(nameElement).toBeInTheDocument()
  expect(nameElement).toHaveClass("name")

  const descriptionElement = screen.getByText(/my description/i)
  expect(descriptionElement).toBeInTheDocument()
  expect(descriptionElement).toHaveClass("description")

  const thumbElement = screen.queryByAltText(/my name Thumb/i)
  expect(thumbElement).toBeInTheDocument()
  expect(thumbElement).toHaveClass("thumb")
})
