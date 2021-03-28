import { render, screen } from "@testing-library/react"
import { DragDropContext } from "react-beautiful-dnd"
import DroppableApplicantsList from "./DroppableApplicantsList"

test("renders a droppable applicants list", () => {
  const items = [
    {
      id: "applicant-id-1",
      name: "applicant name 1",
      description: "applicant description 1",
      thumb: "/applicant/thumb-1",
    },
    {
      id: "applicant-id-2",
      name: "applicant name 2",
      description: "applicant description 2",
      thumb: "/applicant/thumb-2",
    },
  ]
  const { container } = render(
    <DragDropContext>
      <DroppableApplicantsList id="my-id" title="my title" items={items} />
    </DragDropContext>
  )

  const lstCountElement = container.getElementsByClassName("list-count")
  expect(lstCountElement.length).toBe(1)
  expect(lstCountElement[0]).toHaveTextContent(/^2$/)
  expect(container.getElementsByClassName("applicant").length).toBe(2)
})
