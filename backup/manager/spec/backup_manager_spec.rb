# Copyright (c) 2009-2011 VMware, Inc.
require 'spec_helper'

describe BackupManagerTests do
end

describe BackupRotatorTests do

  it "should do nothing with an empty directory" do
    rotator = BackupRotatorTests.create_rotator('empty')
    rotator.run.should be_true
    rotator.pruned.length.should == 0
  end

  it "should do nothing with an invalid directory" do
    rotator = BackupRotatorTests.create_rotator('invalid')
    rotator.run.should be_true
    rotator.pruned.length.should == 0
  end

  it "should calculate midnghts properly" do
    rotator = BackupRotatorTests.create_rotator('empty')
    # manager.time=="2010-01-20 09:10:20 UTC", so...
    rotator.n_midnights_ago(0).should == Time.parse("2010-01-20 00:00:00 UTC").to_i
    rotator.n_midnights_ago(1).should == Time.parse("2010-01-19 00:00:00 UTC").to_i
    rotator.n_midnights_ago(2).should == Time.parse("2010-01-18 00:00:00 UTC").to_i
    rotator.n_midnights_ago(3).should == Time.parse("2010-01-17 00:00:00 UTC").to_i
    rotator.n_midnights_ago(4).should == Time.parse("2010-01-16 00:00:00 UTC").to_i
    rotator.n_midnights_ago(5).should == Time.parse("2010-01-15 00:00:00 UTC").to_i
    rotator.n_midnights_ago(6).should == Time.parse("2010-01-14 00:00:00 UTC").to_i
    rotator.n_midnights_ago(7).should == Time.parse("2010-01-13 00:00:00 UTC").to_i
    rotator.n_midnights_ago(8).should == Time.parse("2010-01-12 00:00:00 UTC").to_i
    rotator.n_midnights_ago(20).should == Time.parse("2009-12-31 00:00:00 UTC").to_i
  end

  it "should bucketize timestamps properly" do
    rotator = BackupRotatorTests.create_rotator('empty')
    backups = {
      rotator.n_midnights_ago(0)+10 => "0+10",
      rotator.n_midnights_ago(0)+20 => "0+20",
      rotator.n_midnights_ago(0)+30 => "0+30",
      rotator.n_midnights_ago(1)+10 => "1+10",
      rotator.n_midnights_ago(1)+20 => "1+20",
      rotator.n_midnights_ago(1)+30 => "1+30",
      rotator.n_midnights_ago(2)+10 => "2+10",
      rotator.n_midnights_ago(2)+20 => "2+20",
      rotator.n_midnights_ago(2)+30 => "2+30",
      rotator.n_midnights_ago(3)+10 => "3+10",
      rotator.n_midnights_ago(3)+20 => "3+20",
      rotator.n_midnights_ago(3)+30 => "3+30",
      rotator.n_midnights_ago(4)+10 => "4+10",
      rotator.n_midnights_ago(4)+20 => "4+20",
      rotator.n_midnights_ago(4)+30 => "4+30",
      rotator.n_midnights_ago(5)+10 => "5+10",
      rotator.n_midnights_ago(5)+20 => "5+20",
      rotator.n_midnights_ago(5)+30 => "5+30",
      rotator.n_midnights_ago(6)+10 => "6+10",
      rotator.n_midnights_ago(6)+20 => "6+20",
      rotator.n_midnights_ago(6)+30 => "6+30",
      rotator.n_midnights_ago(7)+10 => "7+10",
      rotator.n_midnights_ago(7)+20 => "7+20",
      rotator.n_midnights_ago(7)+30 => "7+30",
      rotator.n_midnights_ago(8)+10 => "8+10",
      rotator.n_midnights_ago(8)+20 => "8+20",
      rotator.n_midnights_ago(8)+30 => "8+30",
      rotator.n_midnights_ago(9)+10 => "9+10",
      rotator.n_midnights_ago(9)+20 => "9+20",
      rotator.n_midnights_ago(9)+30 => "9+30",
    }
    buckets = rotator.bucketize(backups)
    buckets.length.should == 8
    buckets[0].length.should == 3
    buckets[0].include?(rotator.n_midnights_ago(1)+10).should be_true
    buckets[0].include?(rotator.n_midnights_ago(1)+20).should be_true
    buckets[0].include?(rotator.n_midnights_ago(1)+30).should be_true
    buckets[1].length.should == 3
    buckets[1].include?(rotator.n_midnights_ago(2)+10).should be_true
    buckets[1].include?(rotator.n_midnights_ago(2)+20).should be_true
    buckets[1].include?(rotator.n_midnights_ago(2)+30).should be_true
    buckets[2].length.should == 3
    buckets[2].include?(rotator.n_midnights_ago(3)+10).should be_true
    buckets[2].include?(rotator.n_midnights_ago(3)+20).should be_true
    buckets[2].include?(rotator.n_midnights_ago(3)+30).should be_true
    buckets[3].length.should == 3
    buckets[3].include?(rotator.n_midnights_ago(4)+10).should be_true
    buckets[3].include?(rotator.n_midnights_ago(4)+20).should be_true
    buckets[3].include?(rotator.n_midnights_ago(4)+30).should be_true
    buckets[4].length.should == 3
    buckets[4].include?(rotator.n_midnights_ago(5)+10).should be_true
    buckets[4].include?(rotator.n_midnights_ago(5)+20).should be_true
    buckets[4].include?(rotator.n_midnights_ago(5)+30).should be_true
    buckets[5].length.should == 3
    buckets[5].include?(rotator.n_midnights_ago(6)+10).should be_true
    buckets[5].include?(rotator.n_midnights_ago(6)+20).should be_true
    buckets[5].include?(rotator.n_midnights_ago(6)+30).should be_true
    buckets[6].length.should == 3
    buckets[6].include?(rotator.n_midnights_ago(7)+10).should be_true
    buckets[6].include?(rotator.n_midnights_ago(7)+20).should be_true
    buckets[6].include?(rotator.n_midnights_ago(7)+30).should be_true
    buckets[7].length.should == 6
    buckets[7].include?(rotator.n_midnights_ago(8)+10).should be_true
    buckets[7].include?(rotator.n_midnights_ago(8)+20).should be_true
    buckets[7].include?(rotator.n_midnights_ago(8)+30).should be_true
    buckets[7].include?(rotator.n_midnights_ago(9)+10).should be_true
    buckets[7].include?(rotator.n_midnights_ago(9)+20).should be_true
    buckets[7].include?(rotator.n_midnights_ago(9)+30).should be_true
  end

  it "should prune a very old backup" do
    rotator = BackupRotatorTests.create_rotator('one_very_old')
    rotator.run.should be_true
    rotator.pruned.length.should == 1
  end

  it "should not prune a very new backup" do
    rotator = BackupRotatorTests.create_rotator('one_very_new')
    rotator.run.should be_true
    rotator.pruned.length.should == 0
  end

  it "should handle a complicated case" do
    rotator = BackupRotatorTests.create_rotator('complicated')
    rotator.run.should be_true
    # 'complicated' is a large dataset that was automatically
    # generated by 'test_directories/complicated/populate.rb', so it
    # is impossible to check it in all possible ways.  But here are a
    # few sanity checks.
    # 1. everything should either be retained or pruned
    (rotator.retained.length + rotator.pruned.length).should == SERVICES*INSTANCES_PER_SERVICE*BACKUPS_PER_INSTANCE
    # 2. should discard all backups more than MAX_DAYS old
    threshold = rotator.n_midnights_ago(BackupRotatorTests::MAX_DAYS)
    rotator.retained.each { |a|
      a[1].should > threshold
    }
    # 3. should retain all of today's backups
    midnight = rotator.n_midnights_ago(0)
    rotator.pruned.each { |a|
      a[1].should < midnight
    }
    # 4. should retain at most one backup per day for the MAX_DAYS (except today)
    (1 .. BackupRotatorTests::MAX_DAYS).each { |day|
      service_count = {}
      rotator.retained.each { |a|
        path = a[0]
        timestamp = a[1]
        if timestamp > rotator.n_midnights_ago(day) && timestamp < rotator.n_midnights_ago(day-1)
          path =~ /\A(.*)\/\d+\Z/
          instance = $1
          service_count[instance] = (service_count[instance]||0) + 1
        end
      }
      service_count.values.each { |count|
        count.should < 2 # not "==1" because our random data might not include any backups for the day
      }
    }
  end

end
