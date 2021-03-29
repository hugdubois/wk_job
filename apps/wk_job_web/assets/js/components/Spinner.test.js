import { render } from "@testing-library/react"
import Spinner from "./Spinner"

describe("renders a spinner", () => {
  test("with default text", () => {
    const { container } = render(<Spinner />)

    expect(container.querySelector(".loading")).not.toBe(null)
    expect(container.querySelector(".text")).toHaveTextContent(/loading.../i)
  })

  test("with custom text", () => {
    const { container } = render(<Spinner text="my text" />)

    expect(container.querySelector(".loading")).not.toBe(null)
    expect(container.querySelector(".text")).toHaveTextContent(/my text/i)
  })
})
