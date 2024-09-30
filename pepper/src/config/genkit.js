import {configureGenkit} from "@genkit-ai/core";
import {firebase} from "@genkit-ai/firebase";

configureGenkit({
  plugins: [firebase({projectId: "robotics-project-team-1"})],
});