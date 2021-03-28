import { render } from "@testing-library/react"
import HiringProcessPipeline from "./HiringProcessPipeline"

test("renders a hiring process pipeline", () => {
  const job = {
    id: "my-id",
    title: "my title",
    pipeline: {
      to_meet: [
        {
          id: "applicant-id-1",
          name: "applicant name 1",
          description: "applicant description 1",
          thumb: "/applicant/thumb-1",
        },
      ],
      in_interview: [
        {
          id: "applicant-id-2",
          name: "applicant name 2",
          description: "applicant description 2",
          thumb: "/applicant/thumb-2",
        },
      ],
    },
  }
  const { container } = render(
    <HiringProcessPipeline
      id={job.id}
      title={job.title}
      pipeline={job.pipeline}
    />
  )

  expect(
    container.querySelector(".hiring-process-pipeline .title")
  ).toHaveTextContent(/my title/i)

  expect(
    container.querySelector(".hiring-process-pipeline .pipeline")
      .childElementCount
  ).toBe(2)

  container
    .querySelector(".hiring-process-pipeline .pipeline")
    .childNodes.forEach((listContainer) => {
      expect(listContainer.className).toBe("list-container")
    })

  // TODO more tests are needed such as drag and drop management
})
