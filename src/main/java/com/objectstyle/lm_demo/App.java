package com.objectstyle.lm_demo;

import java.util.Map;

import org.apache.cayenne.PersistenceState;

import com.google.inject.Binder;
import com.google.inject.Inject;
import com.google.inject.Module;
import com.nhl.bootique.Bootique;
import com.nhl.bootique.job.BaseJob;
import com.nhl.bootique.job.JobMetadata;
import com.nhl.bootique.job.runnable.JobResult;
import com.nhl.bootique.job.runtime.JobModule;
import com.nhl.link.move.Execution;
import com.nhl.link.move.LmTask;
import com.nhl.link.move.annotation.AfterTargetsMerged;
import com.nhl.link.move.runtime.LmRuntime;
import com.nhl.link.move.runtime.task.createorupdate.CreateOrUpdateSegment;
import com.nhl.link.move.runtime.task.createorupdate.CreateOrUpdateTuple;
import com.objectstyle.lm_demo.cayenne.WGame;
import com.objectstyle.lm_demo.cayenne.WTeam;

public class App implements Module {

	public static void main(String[] args) {
		Bootique.app(args).autoLoadModules().module(App.class).run();
	}

	@Override
	public void configure(Binder binder) {
		JobModule.contributeJobs(binder).addBinding().to(SyncJob.class);
	}

	public static class SyncJob extends BaseJob {

		@Inject
		LmRuntime runtime;

		public SyncJob() {
			super(JobMetadata.build(SyncJob.class));
		}

		@Override
		public JobResult run(Map<String, Object> params) {

			LmTask teamSync = runtime
					.getTaskService()
					.createOrUpdate(WTeam.class)
					.sourceExtractor("schedule-team-extractor.xml")
					.task();
			
			LmTask gameSync = runtime
					.getTaskService()
					.createOrUpdate(WGame.class)
					.batchSize(20)
					.stageListener(new GameListener())
					.sourceExtractor("schedule-game-extractor.xml")
					.task();
			
			LmTask gameDeleteSync = runtime
					.getTaskService()
					.delete(WGame.class)
					.batchSize(20)
					.sourceMatchExtractor("schedule-game-extractor.xml")
					.task();
			
			LmTask gameScoresSync = runtime
					.getTaskService()
					.createOrUpdate(WGame.class)
					.batchSize(20)
					.stageListener(new GameListener())
					.sourceExtractor("schedule-game-scores-extractor.xml")
					.task();

			Execution teamResult = teamSync.run();
			Execution gameResult = gameSync.run();
			Execution gameDeleteResult = gameDeleteSync.run();
			Execution gameScoresResult = gameScoresSync.run();

			System.out.println("Teams: " + teamResult.createReport());
			System.out.println("Games: " + gameResult.createReport());
			System.out.println("Games deleted: " + gameDeleteResult.createReport());
			System.out.println("Games scores: " + gameScoresResult.createReport());

			
			return JobResult.success(getMetadata());
		}
	}
	
	
    public static class GameListener {
    	
    	@AfterTargetsMerged
    	public void fixGames(Execution e, CreateOrUpdateSegment<WGame> segment) {
    		
    		segment.getMerged().stream().map(CreateOrUpdateTuple::getTarget)
    		.filter(g -> g.getPersistenceState() == PersistenceState.NEW).forEach(g -> {
    			g.setAwayScore(0);
    			g.setHomeScore(0);
    		});
    	}
    }
}
