// jest-dom adds custom jest matchers for asserting on DOM nodes.
// allows you to do things like:
// learn more: https://github.com/testing-library/jest-dom
import "@testing-library/jest-dom"
import fakeData from "./fake_data"

global.fakeHiringProcessPipelineData = fakeData.hiringProcessPipeline

// fix: react-beautiful-dnd warning on no browser
// see: https://github.com/atlassian/react-beautiful-dnd/issues/1593#issuecomment-624854231
jest.mock("react-beautiful-dnd", () => ({
  Droppable: ({ children }) =>
    children(
      {
        draggableProps: {
          style: {},
        },
        innerRef: jest.fn(),
      },
      {}
    ),
  Draggable: ({ children }) =>
    children(
      {
        draggableProps: {
          style: {},
        },
        innerRef: jest.fn(),
      },
      {}
    ),
  DragDropContext: ({ children }) => children,
}))
