import glob
import os

import basemodel

class Model(basemodel.BaseModel):
    def execute(self, runparams):

        variables = runparams.variables

        # self.logger.fine("\n--> Running maxent")
        # this is for testing the repetitions file
        # if variables['PAR.variable.to.test.repetitions'] > 0:
        #   self.logger.fine("Now Doing repetitions, PAR.variable.to.test.repetitions=%s" % \
        #         variables['PAR.variable.to.test.repetitions'])


        # download the required input data
        self.logger.fine("\n--> scp-collab.download.inputdata.R")
        self.run_r_code( "scp-collab.download.inputdata.R", runparams )

        # remap planning units
        self.logger.fine("\n--> Running scp-collab.permute.coalitions.R")
        self.run_r_code( "scp-collab.permute.coalitions.R", runparams )

        # run Zonation
        self.logger.fine("\n--> Running zonation")
        self.run_r_code( "scp-collab.run.zonation.R", runparams )
        
        self.run_r_code( "scp-collab.eval.z.results.R", runparams )
