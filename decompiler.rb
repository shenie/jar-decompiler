#!/usr/bin/env ruby

require 'fileutils'
require 'ftools'

# 
# Created by Andy Shen (andy@shenie.info)
# Decompiles a jar file.
# Usage:
# ruby decompiler.rb jms.jar
# 

class Decompiler
  def initialize(jar)
    @jar_path = "#{FileUtils.pwd}/#{jar}"
    @output_dir = File.basename(jar, ".jar")
  end
  
  def run
    goto_output_dir do
      `jar xvf #{@jar_path}`
      decompile
      FileUtils.rm_r Dir.glob('**/*.class')
    end
  end

  private

    def goto_output_dir(&block)
      FileUtils.mkdir @output_dir
      FileUtils.cd @output_dir
      block.call
      FileUtils.cd '..'
    end
    
    def decompile
      Dir.glob("**/*.class").delete_if { |f| f =~ /\$/ }.each do |class_path|
        java_file = class_path.sub(".class", ".java")
        `jad -p #{class_path} > #{java_file}`
      end
    end
end

decompiler = Decompiler.new ARGV[0]
decompiler.run

